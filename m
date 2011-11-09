Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1KITl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:41:26 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:46781 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1KITlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:41:25 -0500
X-Authority-Analysis: v=2.0 cv=dNAkaZlb c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=oRLX4Z5ToWcA:10 a=8nJEP1OIZ-IA:10 a=_Lm-D_UbkawqUGxNSlYA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EBAD761.4060501@cfl.rr.com>
Date: Wed, 09 Nov 2011 14:41:21 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: proc filesystem lets you out of a chroot?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought that symlinks could not be followed out of a chroot, but if 
you follow /proc/1/root, you can escape from your chroot.  When open() 
finds that /proc/1/root is a symlink and restarts the name lookup with 
"/", shouldn't that start with the calling process's root and not init's?
