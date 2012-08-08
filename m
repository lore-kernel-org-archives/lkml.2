Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2HHBMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:12:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52809 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076Ab2HHBMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:12:50 -0400
X-Sasl-enc: /8mmx+gIGiK9/98ZSxz2CTRBnpUrEUi8hNlC36b0iRpd 1344388369
Date: Tue, 7 Aug 2012 22:12:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v2] leds: triggers: send uevent when changing triggers
Message-ID: <20120808011245.GC640@khazad-dum.debian.net>
References: <1344369495-21943-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344369495-21943-1-git-send-email-ccross@android.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2012, Colin Cross wrote:
> Some triggers create sysfs files when they are enabled.  Send a uevent
> "change" notification whenever the trigger is changed to allow userspace
> processes such as udev to modify permissions on the new files.
> 
> A change notification will also be sent during registration of led class
> devices or led triggers if the default trigger of an led class device
> is found.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
