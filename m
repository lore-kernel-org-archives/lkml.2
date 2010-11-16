Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab0KPHIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:08:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42854 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab0KPHIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TrgbK/G9CVTg/cgcPZMsRh/lMCfis6jCe5TdHbqTXwWEBqH+4/Wyt8Fm/JRDXkHj9p
         fB/nXQjWwe0GeVjtrI7TKr220flP4fj9hvUaxwwpbN9/M/tFXru2+NeQbESi2LkulAJQ
         1arQByM/NRRxzLL/g+k4oUh2rhuGKbeYP/24A=
Message-ID: <4CE22DF1.3020902@garzik.org>
Date: Tue, 16 Nov 2010 02:08:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113042821.GE18258@parisc-linux.org> <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com> <1289628103.3015.608.camel@mulgrave.site> <4CE22B55.6000404@garzik.org>
In-Reply-To: <4CE22B55.6000404@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:57 AM, Jeff Garzik wrote:
> It is basically your incremental patch + fas216 deadlock fix + several
> more prototype fixes.

oh and removed some dead code from atari_scsi that became 
dead-and-incorrect code.

