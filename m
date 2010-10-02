Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0JBG1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 02:27:13 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:46809 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0JBG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 02:27:12 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Oct 2010 02:27:12 EDT
Date: Sat, 2 Oct 2010 10:19:08 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: [i8k] GIT current's i8k module does not load on Inspiron 8200
 laptops
Message-ID: <20101002081811.GA9024@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux marc 2.6.35-marc-05390-g4a386c3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

the i8k module does no longer load on my DELL Inspiron 8200 laptops. It says this on one machine:

Oct  2 10:06:01 marc kernel: [   16.239867] i8k: unable to get SMM Dell
signature

Due to git log there's nothing changed for a while and I cannot figure out, what's the problem. Does anyone of you?

Cheers,
	Marc

-- 
Marc Koschewski
