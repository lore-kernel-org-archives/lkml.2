Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1GUTkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:40:39 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:53891 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1GUTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:40:36 -0400
From: Michael Brade <brade@informatik.uni-muenchen.de>
Organization: =?iso-8859-1?q?Ludwig-Maximilians-Universit=E4t?= 
 =?iso-8859-1?q?_M=FCnchen?=
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39, 3.0.0-rc7+: complete system freeze with rsync on big directory
Date: Thu, 21 Jul 2011 21:40:28 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6; KDE/4.6.5; x86_64; ; )
References: <201107211119.15496.brade@informatik.uni-muenchen.de> <20110721112804.7aa0043d.taeuber@bbaw.de>
In-Reply-To: <20110721112804.7aa0043d.taeuber@bbaw.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107212140.28573.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oh dear... this isn't true:

> > When I go back to 2.6.37.6 it works fine. I didn't try 2.6.38 yet.

I just froze the system three times in a row on 2.6.37.6 as well. However, it 
seems it takes longer, since I was able to copy 32 GB and 26 GB in two of 
those attempts until it froze.

-- Michael
