Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0EPVI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 17:08:29 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:51627 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab0EPVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 17:08:28 -0400
Message-ID: <4BF05EC9.6070102@blueyonder.co.uk>
Date: Sun, 16 May 2010 22:08:25 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.15 Thunderbird/3.0.4 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: General questiin about SYSFS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the message says, you have to change all instances of SSYSFS to ATTR
 in the rules files in /etc/udev/rules.d to stop those messages
appearing on boot up.

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

