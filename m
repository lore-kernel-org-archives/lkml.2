Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2JBGHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:07:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55064 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab2JBGHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:07:04 -0400
Message-ID: <506A8479.8030103@zytor.com>
Date: Mon, 01 Oct 2012 23:06:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jamie Gloudon <jamie.gloudon@gmail.com>,
        fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
References: <20121001161151.GA2640@darkstar> <20121001162745.GD23181@x1.osrc.amd.com>
In-Reply-To: <20121001162745.GD23181@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 09:27 AM, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 12:11:51PM -0400, Jamie Gloudon wrote:
>> Hey,
>>
>>    Any chance of this getting merge for the 3.7 cycle?
>
> It is not ready yet: http://marc.info/?l=linux-kernel&m=134910582107898
>

Yes, Fenghua who has been working on it unfortunately got preempted at 
an inopportune moment.  It will get fixed.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

