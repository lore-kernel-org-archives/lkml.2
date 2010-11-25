Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0KYUNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:13:19 -0500
Received: from lo.gmane.org ([80.91.229.12]:53750 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0KYUNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:13:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: atomically swap two files
Date: Thu, 25 Nov 2010 20:11:46 +0000
Message-ID: <icmfu2$nga$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 88-97-16-53.dsl.zen.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is it possible to swap two files in an atomic way, so that after the 
syscall either the two files have exchanged names or neither has been 
modified?

I suspect that btrfs could do it, but I'm wondering about ext3/4.

Frank

