Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2CBHDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:03:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2CBHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:03:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6636"; a="168417635"
Message-ID: <4F5070A0.9070609@codeaurora.org>
Date: Fri, 02 Mar 2012 12:32:56 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Ravi Kumar V <kumarrav@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jarod Wilson <jarod@redhat.com>, Anssi Hannula <anssi.hannula@iki.fi>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] rc: Add support for GPIO based IR Receiver driver.
References: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org> <20120228202944.GA9373@balrog> <4F4E1911.5050208@codeaurora.org>
In-Reply-To: <4F4E1911.5050208@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro/Wilson,

On 2/29/2012 5:54 PM, Trilok Soni wrote:
> Hi Mauro/Wilson,
>
> On 2/29/2012 1:59 AM, James Hogan wrote:
>> On Tue, Feb 28, 2012 at 11:21:40AM +0530, Ravi Kumar V wrote:
>>> Adds GPIO based IR Receiver driver. It decodes signals using decoders
>>> available in rc framework.
>>>
>>> Signed-off-by: Ravi Kumar V<kumarrav@codeaurora.org>
>>
>> Looks good to me (but I'm no expert).
>>
>
> Please review this patch.
>
> Thank you James for the review comments.

Please review and check if this patch can be merged in your tree.

---Trilok Soni

--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
