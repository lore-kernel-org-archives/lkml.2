Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0FCUE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:04:27 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:58691 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0FCUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:04:25 -0400
Message-ID: <4C080ABD.5040902@free.fr>
Date: Thu, 03 Jun 2010 22:04:13 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: mount namespace : who mounted what ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was wondering, in a new mount namespace, if it is possible to know 
which mount points were inherited and which were mounted in a new 
namespace ?

I looked at /proc/<pid>/mountinfo and investigated a bit on the mount 
id, but this one is not reliable as it changes in the new namespace. The 
/proc/<pid>/mounts file shows all the mount points visible for the 
process inherited or not.

Any ideas ?

Thanks
   -- Daniel
