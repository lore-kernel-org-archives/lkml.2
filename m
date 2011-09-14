Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1INSyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:54:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63983 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab1INSys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:54:48 -0400
MIME-Version: 1.0
Date: Wed, 14 Sep 2011 20:54:47 +0200
Message-ID: <CAM8FrKKEXUwV6=cMzqi0Le7eadb2XWkrjSQ+jm=QBUJMGPKztQ@mail.gmail.com>
Subject: Regulator constraints and userspace consumer
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I'm currently working with a custom made board based on a OMAP-l138 processor.
I've a few questions about the regulator interface.
The regulators is registered and loaded correctly with well-defined constraints.
I have also registered userspace consumers for each regulator.

* One regulator constraint is set to 1000mV as min and max in the
boardfile. The default voltage for that regulator is 1125mV (the
regulator has this output when powered up).
  What is the most accurate way to set the voltage for these
limitations when the system starts up? There is apparently no check if
the default configuration is within limits as the regulator stays on
1125mV.
  When I'm looking in the userspace consumer (/sys/class/regulator/),
the "max_microvolts" and "min_microvolts" is set to 1000000 but the
"microvolts" is set to 1125000.

* I want to change the output voltage from userspace on demand. What
is the most proper way to do this? If I have understand correctly, the
userspace consumer just exports interface for switching on/off the
regulator, is that correct?


Thanks in advance!

Med vänliga hälsningar / Best regards
Marcus Folkesson
