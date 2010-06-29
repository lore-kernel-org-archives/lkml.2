Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0F2P2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:28:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:22198 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0F2P2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VW7+s0+nIlgG0CJkFlErFFBFrd7g/o8Yk0ijtq+vDmy0nmRB8BHFhN+TQQmlxqZSIT
         lXESpYm5G53122iarxVjy/dJprvZa7j7yJVeMm5KoZOOhAlqcC901iT6EpdV6B3C6jfe
         K2O0U6TgsWsmugvQQABfdN3tn1esJGQM6eGY8=
Date: Tue, 29 Jun 2010 19:28:26 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/25] r852: remove casts from void*
Message-ID: <20100629152823.GA4268@shinshilla>
References: <1277806498-30738-1-git-send-email-segooon@gmail.com>
 <20100629123850.GO19184@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629123850.GO19184@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) The subjects are not helpful.  This one should say something about
> "mtd" but it doesn't.
ok

> 2) These haven't been run through checkpatch.pl.
Sorry for dummy question, but shouldn't code style be consistent?
Somebody who will see old code and patched code will see one line with
wrong-style code then one line with ok then one with wrong etc.
Imho it's better to fix style in one big patch.
