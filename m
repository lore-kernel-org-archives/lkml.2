Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1E2Ht0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:49:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50842 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1E2HtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cUie4zi6Cr4+jvOycOWWxBPjG7aidy70coKgUx5dXXjD3xyTaybTyJAtIuUsT9TDvA
         3itfn5UsfEi+ZRyef4tv1USoTGTnXuFqsmQaLfoBwLagWRXcG7eQxEcfHPHRvQMJmHAc
         39Rx3lfCUytQnkPkyx0cXM8m6QD9ZX7+wFmEc=
Message-ID: <4DE1FA7F.3050308@users.sourceforge.net>
Date: Sun, 29 May 2011 10:49:19 +0300
From: Alberto Mardegan <mardy@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Javier S. Pedro" <maemo@javispedro.com>, linux-input@vger.kernel.org
Subject: Reporting screen/laptop orientation data to userspace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
  the WMI interfaces in some Lenovo Ideapad laptops provide notification
callbacks when the laptop orientation changes, reporting 4 different
values defining the new orientation.

I'd like to extend the ideapad-laptop driver with this information; but
how should it be reported to userspace? I initially thought of the input
subsystem, but I cannot find any suitable event codes; then I would
probably export it as a device under /sys, or are there better options?

Are there other devices which provide coarse orientation data to
userspace, which I might want to use as a reference?
I guess that at least some display screens have this feature.

TIA,
  Alberto

-- 
http://blog.mardy.it <- geek in un lingua international!
