Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2BFBUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:20:19 -0500
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:44925 "HELO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754521Ab2BFBUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:20:18 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Feb 2012 20:20:17 EST
X-Yahoo-Newman-Id: 480649.5996.bm@omp1040.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=a2UWwxPbjoTaUtoEp1qK9RoHw3Rgm+ATDAGjM+DH+/iYJGNch1LQuZSYjA3RNPhVjuSNkotrc2fgkv278YIsTMnxp6cEzL3WiVzmyNST8AhIWybnQ5FRjo9w+4NvvjyoYfr2IMjV/wAfzFGiRffeKV9801xKpgM8d3ds6hQRAVI=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: P8Gf06AVM1mU1ED_S9HhnGniqJBf76n.zYvGfdBjJKyGlTv
 ppEcIfISIA28hK.FPi_ZElAPqJOIT_vGyqC1aNfEmLZFcH0M8ZnIdUeOHaEp
 TUabLgSTS.KNuhzDHikjGk2bck_b7dcZpq6a7GoRziIFwOaDxSE7Jicvz68N
 4MutHNRYjy.5XHtkDKU0eQq.B4Tib_PDsdAhYqnMrFrUsqd3vJHRxTIscdOi
 2QuPT.AvPMEA_QoXJw6Dx6aFSL1AZzGRAg6MfjSEqOdJaF.nPLWWyRb96_9f
 VbmEXWoaCPCzVx7uriPX1xt_hAiHvLpgU7qA6mW2zk.BYm8cUiOWKXu._Hfd
 oLkYBRivzBItvjufMABxC7vIVn6FEdr906K24INXkMuNLLepI2yyGvz0sqAX
 WXx812nAlWo_zyGpYfQaeGVaUNq7.g8DP8MXxcdjwvwmUCRFoTtPKNBNiW31
 AV9QUs5QltphSJmzMOsiNAri7wVZv4qEeVka_HPOPcZCETZm_NGwc
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
References: <20120205220950.812864962@pcw.home.local> <4C7B5EA1-AE40-4E64-92CC-24277900A99E@yahoo.com> <4F2F2445.9080604@cn.fujitsu.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
In-Reply-To: <4F2F2445.9080604@cn.fujitsu.com>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <613D92FB-4573-4301-BC1A-8DA114FE2A5F@yahoo.com>
Cc: Willy Tarreau <w@1wt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (8J2)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 2_0_0_1_8968646_AEbPjkQAATTQTy8kgQJh83GwdPc
Subject: Re: [PATCH 32/91] libsas: remove expander from dev list on error
Date: Sun, 5 Feb 2012 17:14:26 -0800
To: "gaowanlong@cn.fujitsu.com" <gaowanlong@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where is the "From:" tag that would appear in "git log"?

        Luben


On Feb 5, 2012, at 16:52, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> On 02/06/2012 07:48 AM, Luben Tuikov wrote:
> 
>> Isn't this my patch? Are you submitting it as your own?
> 
> 
> No, he just wanna backport to the stable.
> 
>> 
>>        Luben
>> 
>> 
>> On Feb 5, 2012, at 14:10, Willy Tarreau <w@1wt.eu> wrote:
>> 
>>> 2.6.27-longterm review patch.  If anyone has any objections, please let us know.
>>> 
>>> ------------------
>>> 
>>> commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.
>>> 
>>> If expander discovery fails (sas_discover_expander()), remove the
>>> expander from the port device list (sas_ex_discover_expander()),
>>> before freeing it. Else the list is corrupted and, e.g., when we
>>> attempt to send SMP commands to other devices, the kernel oopses.
>>> 
>>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>> Reviewed-by: Jack Wang <jack_wang@usish.com>
>>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>> ---
>>> drivers/scsi/libsas/sas_expander.c |    3 +++
>>> 1 files changed, 3 insertions(+), 0 deletions(-)
>>> 
>>> Index: longterm-2.6.27/drivers/scsi/libsas/sas_expander.c
>>> ===================================================================
>>> --- longterm-2.6.27.orig/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:34.059914940 +0100
>>> +++ longterm-2.6.27/drivers/scsi/libsas/sas_expander.c    2012-02-05 22:34:39.404915902 +0100
>>> @@ -839,6 +839,9 @@
>>> 
>>>   res = sas_discover_expander(child);
>>>   if (res) {
>>> +        spin_lock_irq(&parent->port->dev_list_lock);
>>> +        list_del(&child->dev_list_node);
>>> +        spin_unlock_irq(&parent->port->dev_list_lock);
>>>       kfree(child);
>>>       return NULL;
>>>   }
>>> 
>>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
> 
> 
