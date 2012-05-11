Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2EKQCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:02:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42850 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760186Ab2EKQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:02:06 -0400
Message-ID: <4FAD37F9.4030403@gmail.com>
Date: Fri, 11 May 2012 20:02:01 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to calculate latency for block devices?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

How to properly calculate average latency for block devices?

(read_ticks+write_ticks)/requests or 
(read_ticks+write_ticks+time_in_queue)/requests? (Or just 
time_in_queue/requests?)

Thanks.
