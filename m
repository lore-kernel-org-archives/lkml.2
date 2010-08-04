Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0HDIiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:38:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57516 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HDIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=C3Vm9gmTokbR2HACsVjlK2yfQRBUHh6I24px8HpcchFEFejNVapuSIuWs6GouXrosF
         1ZSSTu9maQp1a+HWAWlCfLUj1mZthUZojuN21ceF5LRrXRTzMlZM0TdKUX7jsFz4uP1C
         nJARLW/MbPX+dP+w0yVo0knFkP9ZL5uxpDw6Q=
MIME-Version: 1.0
Date: Wed, 4 Aug 2010 16:38:12 +0800
Message-ID: <AANLkTi=1DxqLrqVbfRouOBRWg4RHFaHz438X7F1JWL6P@mail.gmail.com>
Subject: question about CONFIG_BASE_SMALL
From: Ryan Wang <openspace.wang@gmail.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

      I noticed CONFIG_BASE_SMALL in different parts
of the kernel code, with ifdef/ifndef.
      I wonder what does CONFIG_BASE_SMALL mean?
And how can I configure it, e.g. through make menuconfig?

thanks,
