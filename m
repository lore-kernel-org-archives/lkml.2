Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2JSBAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:00:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17001 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2JSBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:00:18 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-8e-5080a6217f8b
Message-id: <5080A61F.1080206@samsung.com>
Date: Fri, 19 Oct 2012 10:00:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon fixes for Linux 3.6
References: <50762167.8060806@samsung.com> <20121018172403.GA29562@kroah.com>
In-reply-to: <20121018172403.GA29562@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAV3FZQ0BBhdf8Ftc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M170zGQsesFfse7yPpYFxEVsXIyeHhICJxPP2F+wQtpjEhXvr
	geJcHEICixgl1k6cyAjhdDFJvOv9DlbFK6AlcXfFdDCbRUBVYsvBX2CT2IDi+1/cALI5OEQF
	IiR+9XNAlAtK/Jh8jwXEFhHQkHh59BYLyExmgeWMEkevPgebIyxgJDH/ywGwIiEBX4l3XRuY
	QWxOAX2Jl1eeMoLYzAI6Evtbp7FB2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4BJ9J72Bc1WBxiFGAg1GJh/dyT32AEGtiWXFl7iFGCQ5mJRHe
	lZuAQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tSs1NTC1KLYLJMHJxSDYwZfDd0
	M6VuiYZUnGWaIm1zJNhUW/zrPab5Jm57tlvLf/DKsshJDzKvaPvDPdf26/L1z+4sPtXFsivo
	2xKBrIV2X9nihIU3KN/PqrXZ9vzyj/YLszw1Em8cO3+xTTbu5sbTW7rvm3vOadefyDrBN7lY
	v5ibTcXsw8Z9fce5p9Q5N5beO3V53lslluKMREMt5qLiRAA8CnZUPQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 02:24 AM, Greg KH wrote:
> On Thu, Oct 11, 2012 at 10:31:19AM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> Please pull extcon fixes for Linux 3.6 from:
>>
>>     git://git.infradead.org/users/kmpark/linux-samsung extcon-for-next
>>
>> I've been creating "extcon-for-next" tree at git.infradead.org
>> and rebasing the branch base on your
>> driver-core.git(branch:driver-core-next).
>>
>> This tree contains various small bugfixes and enhancements, fix typos.
>> And extcon-max77693 initialize MUIC register during probe()
>> to unmask internal interrupt of max77693 MUIC device.
> 
> Now that you have a kernel.org account, can you move this tree to
> git.kernel.org, and provide me a signed tag to pull from for this set of
> patches to go into 3.7?
> 

OK, I will move extcon tree to git.kernel.org when extcon git repository is created
and request pull extcon patches with a signed tag  from extcon tree to go into 3.7.

Best Regards,
Chanwoo Choi
