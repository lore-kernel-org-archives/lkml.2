Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0CRIxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:53:45 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:38630 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0CRIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:53:43 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUsAMqGoUtT4vpWPGdsb2JhbACBPYYjk1cBAQEBN7d5hHgE
X-IronPort-AV: E=Sophos;i="4.51,265,1267398000"; 
   d="scan'208";a="52471467"
Message-ID: <4BA1EA13.6040909@coyote.org>
Date: Thu, 18 Mar 2010 09:53:39 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds_f.h whitespace corrections.
References: <1268899193-16034-1-git-send-email-lindley@coyote.org> <4BA1DE50.1080908@cs.helsinki.fi>
In-Reply-To: <4BA1DE50.1080908@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, new patch coming soon..
I misread your reply first and thought you meant function names..That's a
bit more work better done after the code is more readable in the whole
winbond driver.. :)

/Lars

On 2010-03-18 09:03, Pekka Enberg wrote:
> Lars Lindley kirjoitti:
>> +void MDS_SendResult(struct wbsoft_priv *adapter, u8 PacketId,
>> unsigned char SendOK);
> 
> While you're at it, how about fixing up those CamelCase parameter names
> as well?
> 
>             Pekka
> 
