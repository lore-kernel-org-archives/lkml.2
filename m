Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0HXOa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:30:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37839 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751407Ab0HXOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:30:25 -0400
Date: Tue, 24 Aug 2010 10:30:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Raj Kumar <rajkumar278@hotmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Runtime power management during system resume
In-Reply-To: <BLU102-W1030ED196ED7B94722F2A7EB830@phx.gbl>
Message-ID: <Pine.LNX.4.44L0.1008241029000.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Raj Kumar wrote:

> Hi Alan,
>  
> I have implemented the run time power management in my drivers. I have one
> issue regarding System resume.
>  
> When the system sleep is triggered as it is mentioned that Power management
> core will increment the power_usage counter during prepare and decrements when complete
> is called.
>  
> Now I have few questions:
>  
> 1) When the system resume is done, it does not increase the power_usage counter.
>  right?

That's right.

> So Does then the driver need to update the power_usage counter with run time power management
> core and again set it to active means RPM_ACTIVE?

Read section 6 of Documentation/power/runtime_pm.h.  It explains this.

> 2) Suppose device is active, means its power_usage counter is already one, Now during system
> sleep, does the driver first suspend it with run time power management core and then continue
> System suspend?

No.

> 3) Because I have seen the code of power management core and I did not see the that during
> system suspend, run time power management status is updated means RPM_SUSPENDED.
> right?

I don't understand your question.

Alan Stern

