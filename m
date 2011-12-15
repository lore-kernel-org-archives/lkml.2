Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab1LOPDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:03:41 -0500
Received: from mail.tpi.com ([70.99.223.143]:4869 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1LOPDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:03:40 -0500
Message-ID: <4EEA0C39.4050900@canonical.com>
Date: Thu, 15 Dec 2011 08:03:21 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7/0xb9()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun - is your patch from https://lkml.org/lkml/2011/12/5/421 in the 
pipeline ? We've got some test machines that are incurring many 
instances of this warning. I noticed that Wu Fengguang also complained 
about it in https://lkml.org/lkml/2011/11/2/208.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
