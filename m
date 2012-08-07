Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2HGGRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:17:49 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:24722
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab2HGGRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:17:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dI98dI9371Idf9M1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M8DG5G-01-2ZL-02
X-M-MSG: 
Message-ID: <5020B323.4010102@amd.com>
Date: Tue, 7 Aug 2012 14:18:11 +0800
From: Aaron Lu <aaron.lu@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>, Jeff Wu <jeff.wu@amd.com>,
        Lin Ming <minggr@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v4 4/7] scsi: sr: block events when runtime suspended
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com> <1343379650-2867-5-git-send-email-aaron.lu@amd.com> <501B9EE7.1080000@amd.com> <501BE5B2.5040901@pobox.com>
In-Reply-To: <501BE5B2.5040901@pobox.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2012 06:17:13.0694 (UTC) FILETIME=[492E5FE0:01CD7464]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 10:52 PM, Jeff Garzik wrote:
> On 08/03/2012 05:50 AM, Aaron Lu wrote:
>> Hello,
>>
>> Not sure if I should use EXPORT_SYMBOL or EXPORT_SYMBOL_GPL, any
>> comments?
>
> Typically you follow the pattern of similar exports in the file (or in
> the API, if no others are in the file).

Thanks Jeff for your suggestion, and I'll keep using EXPORT_SYMBOL.
If anyone thinks this is wrong, please kindly let me know, thanks.

-Aaron

