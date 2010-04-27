Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0D0Pio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:38:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24619 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0D0Pin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:38:43 -0400
Message-ID: <4BD70485.1070203@oracle.com>
Date: Tue, 27 Apr 2010 08:36:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: linux-next: April 27 (wireless/libertas warnings)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BD70502.00D7:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
include/linux/kernel.h:376:1: warning: this is the location of the previous definition
drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
include/linux/kernel.h:376:1: warning: this is the location of the previous definition

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
