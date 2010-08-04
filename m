Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab0HDTEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:04:13 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:63167 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab0HDTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:04:09 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 15:04:09 EDT
Message-ID: <4C59B444.7080609@nortel.com>
Date: Wed, 04 Aug 2010 12:41:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mount notification question
References: <4C5734A2.7070400@free.fr>
In-Reply-To: <4C5734A2.7070400@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2010 18:41:09.0931 (UTC) FILETIME=[9B3F1FB0:01CB3404]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 03:12 PM, Daniel Lezcano wrote:
> 
> Hi all,
> 
> is there a way to be notified when a mount occurs on the system ?

Have you looked on google?  The link is a bit misleading but they do
give a way to do it (not using inotify).

http://stackoverflow.com/questions/1113176/how-could-i-detect-when-a-directory-is-mounted-with-inotify

Chris

-- 
The author works for GENBAND Corporation (GENBAND) who is solely
responsible for this email and its contents. All enquiries regarding
this email should be addressed to GENBAND. Nortel has provided the use
of the nortel.com domain to GENBAND in connection with this email solely
for the purpose of connectivity and Nortel Networks Inc. has no
liability for the email or its contents. GENBAND's web site is
http://www.genband.com
