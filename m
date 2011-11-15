Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1KOU4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:56:20 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53815 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1KOU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:56:18 -0500
Message-ID: <4EC2D1EC.4010605@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 02:26:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: carla.sella@gmail.com
CC: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: BUG: suspend/resume does not work on G62 notebook PC
References: <4EB53C46.1060301@gmail.com>
In-Reply-To: <4EB53C46.1060301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111520-2000-0000-0000-00000136467C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding linux-pm mailing list to CC.]

On 11/05/2011 07:08 PM, Carla Sella wrote:
> Hello,
> I need to report a bug on  suspend/resume that's not working on my HP
> G62 notebook PC.
> I've been having this problem since testing Ubuntu Natty Beta 1 iso and
> I'm still having it with Ubuntu Oneiric.
> My laptop is a HP  model G62.
> 
> During the "Extended Suspend/Resume test"
> (http://testcases.qa.ubuntu.com/System/SuspendResume), all tests run
> with "sudo /usr/share/checkbox/scripts/suspend_test --full" fail with 
> message: "SUSPEND FAILED, did not go to sleep".
> Also Hibernate/Resume smoke test does not work, the screen goes black
> for a few seconds, more or less 15 and then password is required and you
> go back to the users session.
> This is the bug opened on launchpad with all the details:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/752881
> 

Thanks,
Srivatsa S. Bhat

