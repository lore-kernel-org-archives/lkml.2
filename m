Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1DERkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:40:14 -0400
Received: from lo.gmane.org ([80.91.229.12]:57009 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1DERkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:40:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Poelzleithner <poelzi@poelzi.org>
Subject: [ANN] ulatencyd 0.5.0
Date: Tue, 05 Apr 2011 19:33:54 +0200
Message-ID: <4D9B5282.6000308@poelzi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: lwn@lwn.net
X-Gmane-NNTP-Posting-Host: 91-64-128-149-dynip.superkabel.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm happy to announce ulatencyd 0.5.0.
This is a new major release towards prefect user experience on moderns
Linux Desktops.

What is it ?
============

ulatencyd is a scriptable daemon which constantly optimises the Linux
kernel for best user experience.
The default configuration tries to increase the responsiveness for a
typical desktop system and protects the system from malicious
processes/groups.
With a different configuration all other types of systems can be
adjusted as well.

Website: https://github.com/poelzi/ulatencyd/

• Latest Release:
  https://github.com/poelzi/ulatencyd/downloads
• Package Repos:
  https://github.com/poelzi/ulatencyd/wiki

Major changes since 0.4.0
=========================
  • Policykit support
  • Configs for single task & games
  • XFCE & LXDE support
  • updated documentation
  • GUI/CLI updates
  • cli/gui client called ulatency
  • simplerules module for easy to handle rules
  • instant rules that are executed without delay.
  • enhancements to the dbus interface
  • better realtime support
  • Systemd compatibility
  • IO bottleneck detector
  • Bugfixes

kind regards
 Daniel Poelzleithner

