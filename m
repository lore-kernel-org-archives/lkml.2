Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0DMEwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:52:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64944 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0DMEwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=q8KXLfJygHWv3cAiZWChZbrNRKptCtoaN30z+C+USdhfrSllN7/7XpRmQZy+mmUvNE
         drGaMAewQ7b2kyj5QORoZ/z6OqyyWfNQ4Ympabw0Cuvew1Q6sZvDPmAFtPjNBzJ8cPFV
         NjlWvHrdonIGJBZr9NM3JuvfxWRgOy9YbpMQ4=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 12 Apr 2010 21:51:47 -0700
Message-ID: <m2s43e72e891004122151n2677a158o7f9aa8d054bf058e@mail.gmail.com>
Subject: Compat-wireless for 2.6.34 - 802.11 and bluetooth backported
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're up to 2.6.34-rc4 upstream but we hadn't released a respective
compat-wireless stable [1] tarball yet. I finally got some time so
just posted one up [2], this gives us the 2.6.34-rc4 wireless
subsystem, bluetooth subsystem and new wireless/bluetooth drivers
compilable and installed on older kernels. Please report any issues
ASAP. For details on changes you can refer to the
ChangeLog-2.6.34-rc4-wireless [3].

I only did a quick build test against 2.6.31 and it seems to compile
fine :), more compile tests reports against older kernels and actual
loading tests reports against different kernels are greatly
appreciated.

 Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/compat-wireless-2.6.34-rc4.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/ChangeLog-2.6.34-rc4-wireless
