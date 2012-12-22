Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2LVDxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:53:20 -0500
Received: from mailreg.NCTU.edu.tw ([211.76.241.6]:61398 "EHLO
	mailreg.nctu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2LVDxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:53:19 -0500
Message-ID: <6ec09bb641d19e31e173f0d7f338cdfb.squirrel@webmail.nctu.edu.tw>
Date: Sat, 22 Dec 2012 11:37:02 +0800
Subject: The relationship between flag: BH_Uptodate & BH_Dirty in 
 buffer_head
From: cyhung.cs00g@nctu.edu.tw
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=Big5
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I want ask a question.

As we know, structure buffer_head has a member called b_state.
And this state could be defined by many flags.

The question is that, I want to know the relationship between BH_Uptodate
& BH_Dirty.

If a data is verified, the BH_Dirty will setup, and what about BH_Uptodate?

Under what circumstance the BH_Uptodate would be set up?


Thanks. :)

