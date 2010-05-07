Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0EGFgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:36:20 -0400
Received: from smtp.nokia.com ([192.100.105.134]:25635 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0EGFgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:36:18 -0400
Date: Fri, 7 May 2010 08:32:03 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jiri Olsa <jolsa@redhat.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
       "ysato@users.sourceforge.jp" <ysato@users.sourceforge.jp>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "dhowells@redhat.com" <dhowells@redhat.com>,
       "kyle@mcmartin.ca" <kyle@mcmartin.ca>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>, "hare@suse.de" <hare@suse.de>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCH 12/13] drivers/usb/musb: removing redundant ifdefs
Message-ID: <20100507053203.GC10123@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
 <1273167377-14270-13-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1273167377-14270-13-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 May 2010 05:32:38.0996 (UTC) FILETIME=[B4F79940:01CAEDA6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 06, 2010 at 07:36:16PM +0200, ext Jiri Olsa wrote:
>wbr,
>jirka
>
>

good catch but please add a body here. This problem appeared because 
those used to be CONFIG_ARCH_OMAP34XX.

>Signed-off-by: Jiri Olsa <jolsa@redhat.com>

after adding a body, you can have my:

Acked-by: Felipe Balbi <felipe.balbi@nokia.com>

-- 
balbi

DefectiveByDesign.org
