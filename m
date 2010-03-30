Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0C3RIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:08:31 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42010 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0C3RI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cTgJAbuXb7PMjKHTS609QmrKPANSWnM83Qum0L6ZUnj13nwcmj/rblGWQE7TadFg3X
         ty79kxJ4z08LE/vuvR72aWtU5IJvIYeDE4pKcNhfhJ6r+0MJL1WY+vHzQJAeQl1COiz4
         mJblFLnJ7MElkTZY9kyDz1IWb++x0Ic/FZ8vg=
MIME-Version: 1.0
In-Reply-To: <20100330165645.GB25095@tux>
References: <1269963873-2070-1-git-send-email-luisbg@ubuntu.com>
	 <20100330165645.GB25095@tux>
Date: Tue, 30 Mar 2010 18:08:26 +0100
X-Google-Sender-Auth: cfc96c6752df01aa
Message-ID: <506b70dc1003301008r7079b9c7u96249c28d67a5bdd@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath: fix code readability in regd.c
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 5:56 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Mar 30, 2010 at 08:44:33AM -0700, Luis de Bethencourt wrote:
>> This is a patch to the ath/regd.c file that fixes two code
>> readability issues. A space between to separate two defines
>> and the indentation inside the ath_redg_is_eeprom_valid
>> function.
>
> Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> You can drop netdev and linux-kernel from future linux-wireless e-mails
> like this one.
>
>  Luis
>

OK. Will do.

Luis
