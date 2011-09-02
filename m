Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1IBV24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:28:56 -0400
Received: from nm4.bullet.mail.sp2.yahoo.com ([98.139.91.74]:46719 "HELO
	nm4.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755986Ab1IBV2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:28:55 -0400
X-Yahoo-Newman-Id: 784138.53732.bm@omp1015.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=X8zrJVl+Fzs3w0yj/FjAbFhPZzkokLXhLWg63WVq2hDVStb7J0VVHmb/ISPhpPrOdTgb/hxFZbXE3tV9zXRPcOdFmuXr7Lb+0c6t1yvOiBfh2H7jLJs0nda9f+nTsyeHmgETC9MTVHVyeoeyS1g/mkgqgW6a+FxUfDqjUhkWZDc=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2QrEmv8VM1nVNko6D2gCzKlO0pXrBKMwAfGt1Rg1Vx6wffA
 y2AQ4fBy8iM1FoEl8zdsgOvu2FgxLkAeBAPz9kY.pzlBBVBecEIN.q83dVEe
 sCtCA6G6EFaI0cDnmYuVqtzshIk.caq.BIk3TmG5OtGpBCskr9kqiux2VliJ
 AcrIxtQMm2AYgDN6IFOo2ngtABE146Wj7D__HkHcLWzhNzAKssvrUGwalt5b
 M5_S7B5UnndsiGrJvU7ZNURLiC3LNKuvEcKeSMCXZniqJWqr12YT3rRfvqDX
 zsnqtBm4IrD3etclpYjRhNCcL2lFHdjkpXjE82eQfztsiA_Ml9.oCw55mhLT
 Ks7fviS_cw1fBfNMDDWzvmSfS5g8KfdbMkHHr_H0OJF1nSJKkxc2zL3VxHCt
 WzUqt9Eyl0mX0IWm__Q6yTnLKRp6Xyu9OQEQE_wRRN2Nw52FT1pkMp6K6aAt
 l9ANAaswwiysu1nKW_YlBv3yHqJwOiXFrgAw7kjeX0TKCX0P.QhKpAOWTCE_
 zAhU3SPYTjzYOJgUYN4jYNXAX.B7NefnC1iFdEmDRCvnqqex9wRtwIas-
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
References: <CAM9Y=f6eSgxsbrO11d0ux72NJip14xGQDeX84VWb9uiBtEVsjA@mail.gmail.com> <20110902181826.GA29848@kroah.com> <CB97E92C-3990-418B-BA04-94073E011ECE@yahoo.com> <20110902192250.GA440@kroah.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
In-Reply-To: <20110902192250.GA440@kroah.com>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <F4F1DCC3-F173-47B8-BD90-E868850E55ED@yahoo.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb-devel@lists.sourceforge.net>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>
X-Mailer: iPhone Mail (8J2)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 1_7616844_AEjPjkQAASNqTmEv9Qyu4xcbL3Y
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Fri, 2 Sep 2011 14:28:50 -0700
To: Greg KH <greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 2, 2011, at 12:22, Greg KH <greg@kroah.com> wrote:

> On Fri, Sep 02, 2011 at 12:08:44PM -0700, Luben Tuikov wrote:
>> On Sep 2, 2011, at 11:18, Greg KH <greg@kroah.com> wrote:
>> 
>>> On Fri, Sep 02, 2011 at 02:24:36PM +0800, Daniel J Blueman wrote:
>>>> Hi Luben, Greg, Matthew,
>>>> 
>>>> Any plan for reviewing and accepting this patch [1] yet? I'm still
>>>> seeing the symptoms on USB 3 SATA bridges with linux-3.0+.
>>> 
>>> I needed an ack from Matthew before I could take it.
>>> 
>>> Matthew?
>> 
>> 
>> He acked it already: http://marc.info/?l=linux-kernel&m=128950140420081&w=2
>> 
>> But interestingly enough, it never made it into your tree. 
> 
> Odd, you did, and I found the resend I asked for in my archives, but I
> don't see it in the tree, I don't know what happened here, sorry.
> 
> I'll go queue it up when master.kernel.org comes back up, sorry about
> that.

Are you sure it's mine. I don't remember resending it other than the "take 2" thread (link above).

        Luben

