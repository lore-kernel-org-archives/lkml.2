Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1CJJi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:38:26 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:56237 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab1CJJiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:38:25 -0500
Message-ID: <4D789C0D.90702@blueyonder.co.uk>
Date: Thu, 10 Mar 2011 09:38:21 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.38-rc8-git1 make headers_install failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, the failure is actually in headers_check in both headers_install 
and headers_install_all.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

