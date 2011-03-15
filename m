Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1COLV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:21:56 -0400
Received: from rrzmta4.uni-regensburg.de ([194.94.155.55]:46821 "EHLO
	rrzmta4.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab1COLVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:21:54 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 07:21:54 EDT
Message-Id: <4D7F5828020000A10000557D@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 15 Mar 2011 12:14:32 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: mount option "nosymlink" (for /dev/shm)?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

considering https://bugzilla.novell.com/show_bug.cgi?id=665479 I wonder: Why isn't there a mount option "nosymlink"?
>From my little knowledge of UNIX history I think at the time when "nodevs" and "nosuid" ere invented, there did not exist symbolic links. So it might be natural to have a mount option "nosymlink". I don't know if other security problems are remaining unfixed ading this.
Also, the mount option will prevent symbolic links from being created through the file POSIX system interface, but not from the kernel-side.

Regards,
Ulrich
P.S: I'm not subscribed to the list, so if your response should reach me, please CC: -- thanks


