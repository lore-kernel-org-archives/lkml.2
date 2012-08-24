Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab2HXPTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:19:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53418 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab2HXPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:19:50 -0400
Date: Fri, 24 Aug 2012 11:19:48 -0400 (EDT)
Message-Id: <20120824.111948.680531915905273128.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: eric.dumazet@gmail.com, ncardwell@google.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: David Miller <davem@davemloft.net>
In-Reply-To: <50378B35.80307@lwfinger.net>
References: <50369925.3050705@lwfinger.net>
	<1345757200.5904.1890.camel@edumazet-glaptop>
	<50378B35.80307@lwfinger.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 24 Aug 2012 09:09:57 -0500

> I usually get failures on the first or second try. A kernel built from
> "git checkout c862815" gets the following wget output:
> 
> ============================================================================
> --2012-08-23 21:50:32--
> --https://bugzilla.redhat.com/show_bug.cgi?id=847525
> Resolving bugzilla.redhat.com (bugzilla.redhat.com)... 209.132.183.69
> Connecting to bugzilla.redhat.com
> (bugzilla.redhat.com)|209.132.183.69|:443... connected.
> OpenSSL: error:0D0680A8:asn1 encoding routines:ASN1_CHECK_TLEN:wrong
> tag
> OpenSSL: error:0D07803A:asn1 encoding routines:ASN1_ITEM_EX_D2I:nested
> asn1 error
> OpenSSL: error:0D08303A:asn1 encoding
> routines:ASN1_TEMPLATE_NOEXP_D2I:nested asn1 error
> OpenSSL: error:0D08303A:asn1 encoding
> routines:ASN1_TEMPLATE_NOEXP_D2I:nested asn1 error
> OpenSSL: error:1409000D:SSL routines:SSL3_GET_SERVER_CERTIFICATE:ASN1
> lib
> Unable to establish SSL connection.
> ============================================================================

This looks like full-on data corruption to me.
