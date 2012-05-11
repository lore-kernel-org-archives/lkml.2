Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2EKIhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:37:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10028 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab2EKIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:37:40 -0400
X-AuditID: cbfee612-b7cd7ae00000275e-9e-4faccfcdcc1f
Date: Fri, 11 May 2012 08:37:33 +0000 (GMT)
From: AMIT SAHRAWAT <a.sahrawat@samsung.com>
Subject: =?windows-1252?Q?Re:_Re:_Re:_[Problem]NFS_Server_=96?=
 =?windows-1252?Q?=09_Um=3Fount_results_in_Device_Busy.?=
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Reply-to: a.sahrawat@samsung.com
MIME-version: 1.0
X-MTR: 20120511082621200@a.sahrawat
Msgkey: 20120511082621200@a.sahrawat
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120511082621200@a.sahrawat
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <373541.55191336725451746.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4B8bmKY017844

Hi Bruce,
Sorry it was the mail composer - I did not check mark the plain text option.

We need an opinion.
We will be using around 15 NFS client mounted - with one NFS Server. We are try to make out how many NFSD should we start at the NFS Server.
It all depends upon the load - these 15 NFS clients are going to generate. But is there any default number - we should use to start with? like 1 per NFS client mount?
Please share your advise on this.

Thanks & Regards,
Amit Sahrawat

------- Original Message -------
Sender : J. Bruce Fields<bfields@fieldses.org>
Date : May 10, 2012 17:46 (GMT+05:30)
Title : Re: Re: [Problem]NFS Server – Um?ount results in Device Busy.

On Thu, May 10, 2012 at 11:54:43AM +0000, AMIT SAHRAWAT wrote:
> 
> 
Hi Bruce,

> 


> 
Thanks for instant reply.


Could you turn off html formatting on your mail?

> 
The option you mentioned is working. 'exportfs -f'

> 
Actually it is not mentioned anywhere - even when checked for options:

> 
#> exportfs -h
exportfs: invalid option -- 'h'
usage: exportfs [-aruv] [host:/path]



Sorry, it looks like the help test could be improved!  Patches
welcomed....

It is documented in the exportfs man page.

> 
But - when tried to give - '-f' option it is working.

> 
Then on checking the code for exportfs - got to know the working of '-f' option.

> 
I think it should work. I will check with a number of scenario  - to check there is no blockage for other mount points - at the time 'exportfs -f' is being run. Please reply if it wont :)


If no clients are using the export, it should work.

--b.



Thanks & Regards,
Amit Sahrawatÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
