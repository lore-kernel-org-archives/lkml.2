Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab1JXQ1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:27:34 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:47651 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1JXQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:27:32 -0400
Message-ID: <4EA5913D.7090004@genband.com>
Date: Mon, 24 Oct 2011 10:24:29 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Denilson_Figueiredo_de_S=E1?= <denilsonsa@gmail.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Linux USB HID should ignore values outside Logical Minimum/Maximum
 range
References: <op.v3q34la3dsdv5o@localhost>
In-Reply-To: <op.v3q34la3dsdv5o@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Oct 2011 16:24:38.0812 (UTC) FILETIME=[6D320DC0:01CC9269]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18470.000
X-TM-AS-Result: No--6.779800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2011 05:42 AM, Denilson Figueiredo de Sá wrote:

> It may even happen to send an out-of-range value for one axis, but a
> valid value for another axis. The code should be prepared for that
> (ignore one, but keep the other).

In this case what should be used for the "invalid" axis value?  The 
previous value?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
