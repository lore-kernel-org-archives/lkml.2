Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2AOX2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 18:28:05 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:50967 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2AOX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 18:28:04 -0500
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 15 Jan 2012 23:29:33 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: linux-kernel@vger.kernel.org
Subject: [kmemleak report 0/2] kernel 3.1.6, x86_64
Message-ID: <20120115222932.GA24330@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like memory leaks are “eating” 1G+ after only 1 week uptime … that's
not nice.

I get 2 types of kmemleak backtraces, most likely 2 different issues, thus
2 seperate mails will follow as reply to this mail.

-- 
Roland Eggner 
