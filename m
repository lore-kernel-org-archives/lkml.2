Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0GANrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:47:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53652 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0GANrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NW6uomVsfhP8AATUPVllcLhO1gUWp8nxwkkIfDTLvtkFjxefSIiFQefGKW29VQFr84
         TZa9xSAdSgSIlUFBCBZxsQX5AXjdtHr3gxCQIJ8Q1Av6AKfx+GUu4Z+Ke3A64IKI6Nl/
         KqDBtyH7KnTYifj5ec7X/I6rpj3ongy1puRbQ=
From: Afzal Mohammed <lazfamam@gmail.com>
To: tomi.valkeinen@nokia.com
Cc: ville.syrjala@nokia.com, tj@kernel.org, lazfamam@gmail.com,
       linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP:DSS2:OMAPFB: Fix probe error path
Date: Thu,  1 Jul 2010 19:10:00 +0530
Message-Id: <1277991601-16528-1-git-send-email-lazfamam@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Is this change ok instead of having sysfs entry removal in omapfb_free_resources() ?
Hope this change makes probe look more of a remove mirror.

Regards
Afzal
