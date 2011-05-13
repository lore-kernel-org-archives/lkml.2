Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1EMSNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:13:36 -0400
Received: from mail.kionix.com ([66.152.113.154]:58314 "EHLO mail.kionix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1EMSNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:13:33 -0400
X-ASG-Debug-ID: 1305310411-063500cd0000-xx1T2L
X-Barracuda-URL: http://10.0.0.213:8000/cgi-bin/mark.cgi
From: Chris@vger.kernel.org, Hudson@vger.kernel.org
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: [PATCH]input: Add support for Kionix KXTJ9 accelerometer
Subject: [PATCH]input: Add support for Kionix KXTJ9 accelerometer
Date: Fri, 13 May 2011 14:13:25 -0400
Message-Id: <1305310406-9870-1-git-send-email-chudson@kionix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Barracuda-Connect: UNKNOWN[10.0.0.125]
X-Barracuda-Start-Time: 1305310411
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at kionix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Kionix KXTJ9 digital tri-axis accelerometer.  
The driver uses i2c for hardware communication, input for passing data to the 
application layer, and sysfs to handle system calls.  There were a few warnings 
when I ran checkpatch.pl, all concerning the use of kstrto* in preference to 
simple_strtoul but am concerned that this change may affect backwards 
compatibility.  Please let me know if I need to change anything in order to get 
this merged.
