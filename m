Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab1EHSuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:50:22 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:49792 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab1EHSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:19 -0400
Date: Sun, 8 May 2011 20:42:08 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/14] Fix HPFS
Message-ID: <alpine.DEB.2.00.1105082019230.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This series of patches fixes the HPFS filesystem in 2.6.39. HPFS was 
broken in 2.6.39-rc1 due to big kernel lock removal. These patches also 
make it portable, I tested it on big endian machines.



BTW. would you also like to commit my another filesystem (SpadFS) to the 
Linux kernel? It is at 
http://artax.karlin.mff.cuni.cz/~mikulas/spadfs/download/spadfs-0.9.12.tar.gz
It is very small (300kB), it uses crash counts instead of journaling to 
keep itself consistent, it stores inodes directly in directories, saving 
one seek on opening files and it uses extendible hashing for directory 
organization.

Mikulas
