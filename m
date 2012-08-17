Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab2HQOSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:18:01 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50040 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427Ab2HQORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:17:51 -0400
X-Sasl-enc: gaBhPKLnsY6megRU35VZkmfHX508xZI+geCM9qV7MY/r 1345213070
Date: Fri, 17 Aug 2012 11:17:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pekka Enberg <penberg@kernel.org>
Cc: ibm-acpi-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: Re: [PROBLEM] thinkpad_acpi: unhandled HKEY event 0x6040
Message-ID: <20120817141748.GA12934@khazad-dum.debian.net>
References: <CAOJsxLEb+J=p8Kd782VWPm0ft3D9ujOnV0x_Av+fjWp6QiTHQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEb+J=p8Kd782VWPm0ft3D9ujOnV0x_Av+fjWp6QiTHQQ@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, Pekka Enberg wrote:
> [ 3129.616297] thinkpad_acpi: unhandled HKEY event 0x6040
> [ 3129.616298] thinkpad_acpi: please report the conditions when this
> event happened to ibm-acpi-devel@lists.sourceforge.net
> [ 3129.616949] thinkpad_acpi: undocked from hotplug port replicator
> [ 3129.617065] ACPI: \_SB_.GDCK - undocking
> [ 3144.184916] ACPI: \_SB_.GDCK - docking
> [ 3144.185204] ACPI: Unable to dock!
> 
> and the monitor doesn't come up.

The monitor doesn't come up because of something else, check the GPU drivers
and userspace.  And also why the docking failed...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
