Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1DUVax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:30:53 -0400
Received: from office.neopsis.com ([78.46.209.98]:54542 "EHLO
	office.neopsis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1DUVaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:30:52 -0400
X-Greylist: delayed 1999 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 17:30:51 EDT
Message-ID: <4DB09A38.5000902@dbservice.com>
Date: Thu, 21 Apr 2011 22:57:28 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: npiggin@suse.de
Subject: Regression caused by 8969960 (mm: vmap area cache)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My intel atom mini-itx board doesn't boot anymore after said commit. The 
last messages I see in the console indicate that the kernel has just 
switched to the nouveau fb driver. Reverting the commit on top of the 
latest master does not seem to help.

tom

