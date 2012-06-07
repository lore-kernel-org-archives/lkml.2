Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2FGTkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:40:07 -0400
Received: from www84.your-server.de ([213.133.104.84]:45017 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2FGTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:40:05 -0400
Message-ID: <1339098025.13885.5.camel@wall-e>
Subject: Re: [PATCH 03/13] remove dead code
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 21:40:25 +0200
In-Reply-To: <201206071704.39688.oliver@neukum.org>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
	 <1339057243-10029-4-git-send-email-stefani@seibold.net>
	 <201206071704.39688.oliver@neukum.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.06.2012, 17:04 +0200 schrieb Oliver Neukum:
> > 
> > All code which use processed_urb can be eliminated.
> 
> If you eliminate it, how do you balance the completion?
> 
> 	Regards
> 		Oliver

This was dead code, the process_urb was never used, there was no code
which set the value to false.

The completion is handled in the skel_read() function by the "if
(ongoing_io)" path.

Greetings,
Steffi

