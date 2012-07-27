Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2G0R46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:56:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58829 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2G0R44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:56:56 -0400
Date: Fri, 27 Jul 2012 13:56:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, lwn@lwn.net
Subject: An Andre To Remember
Message-ID: <20120727175655.GA23784@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	An Andre To Remember
	July 2012

Linux lost a friend and advocate this month.  Though never a household
name, Andre Hedrick had a positive impact on everyone today running
Linux, or using a website, with any form of IDE (ATA) or SCSI storage
-- that means millions upon millions of users today.

For a time, Andre interacted with practically every relevant IDE
drive and controller manufacturer, as well as the T13 standards
committee through which IDE changes were made.  He helped ensure
Linux had near-universal IDE support in a hardware era when Linux
support was a second thought if at all.  As the Register article[1]
noted, with CPRM and other efforts, Andre worked to keep storage a
more open platform than it might otherwise have been.

[1] http://www.theregister.co.uk/2012/07/26/andre_hedrick/

Andre also played a role in IDE technology coalescing around the idea
of a "taskfile", which is IDE-speak for an RPC command issued to a
disk drive, and the RPC response returned from the drive.  It was
very important to Andre that the kernel have a "taskfile ioctl",
an API enabling full programmable access to the disk drive.  At the
time, a more limited "cmd ioctl" API was the best option available,
but Linux's cmd ioctl did not give users full and complete access to
their own disk drive.

Andre's taskfile concept was a central component of the current,
rewritten-from-scratch Linux IDE driver "libata."  libata uses an
"ata_taskfile" to communicate with all IDE drives, whether from a
decade ago or built yesterday.  The taskfile concept modernized
IDE software, by forcing the industry to move away from a slow,
signals-originated register API to a modern, packetized RPC messaging
API, similar to where SCSI storage had already been moving.

I spent many hours on the phone with Andre, circa 2003, learning all
there was to know about ATA storage, while writing libata.  Andre could
be considered one of the grandfathers of libata, along with Alan Cox.
I became friends with Andre during this time, and we talked a lot.

Andre was unquestionably smart, driven and an advocate for Linux user
freedom.

Andre was also mentally ill.  Some of those hours spent on the phone
with him were not geeky discussions, but me patiently listening to
paranoid thoughts about kernel developer conspiracies, and even
more patiently describing how he was simply misunderstanding and
misapplying the development process and/or basic code details.
Andre would receive engineering feedback on some of his changes,
and wonder why the engineer reviewing his changes was conspiring to
shoot down his obviously-needed changes.  At some point, paranoia
and mental illness makes you difficult to work with, which starts a
nasty feedback loop feeding further paranoia and stress.

Perhaps it is the nature of intelligence itself, or just the nature
of computer science, but our profession seems to have a higher
than average rate of bipolar disorder and other mental illnesses.
A Beautiful Mind comes to mind, as does my own purely anecdotal
observations of others as a kernel developer and maintainer.  Whatever
the reason, Andre is not the only developer I've encountered who sees
conspiracies, wheels-within-wheels in the feedback they receive.

Although I was truly shocked by the news of Andre's suicide, it always
seemed like Andre was continually stressed out, when I knew him.
When spending long hours discussing kernel and storage industry
politics over the phone with Andre, I found myself constantly advising
him to relax, to take a break from computing.

This is a time for grief and a time for celebration of Andre's
accomplishments, but also it is a time to look around at our fellow
geeks and offer our support, if similar behavioral signs appear.

There is no computing project that is worth your life.  Turn off the
computer.  Seek help.  Get outside, enjoy the green grass, the
birds in the trees.  Talk to people you know.  Talk to strangers!
Drive to Wisconsin, and find out whatever it is they do there.
Build a treehouse.  Park on a parkway and drive on a driveway.
Make a macaroni necklace.  Visit a dairy.  Climb a rock.  Seek life.

Life is so much more than code.

Rest in peace Andre,

	Jeff Garzik
	friend and libata author


PS. Remembering Andre website: http://hedrick4419.blogspot.com/

