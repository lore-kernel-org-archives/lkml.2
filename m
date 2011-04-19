Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1DSUou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:44:50 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34306 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab1DSUot convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
Date: Tue, 19 Apr 2011 15:44:47 -0500
Message-ID: <BANLkTinKUc17SevjYGpawqcCqnZpLMEhDQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] usb: gadget: Make mass_storage pass USBCV MSC
 Compliance tests
From: "Sonasath, Moiz" <m-sonasath@ti.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, mina86@mina86.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger,

On Tue, Apr 19, 2011 at 8:33 AM, Roger Quadros <roger.quadros@nokia.com> wrote:
>
> Hi,
>
> The first patch makes composite framework support a mechanism of defering
> setup transfer's data/status phase.
>
> Second patch makes f_mass_storage use that mechanism.
>
> Together they help the composite devices using f_mass_storage interface to
> pass USBCV Mass Storage Class compliance tests.
>
> ---
> Roger Quadros (2):
>  usb: gadget: composite: Allow function drivers to defer setup
>    responses
>  usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests

Apart from the comments going on, With these patches I see USBCV MSC
tests passing. thanks for the effort Roger :)

--Acked

>
>  drivers/usb/gadget/composite.c      |   61 ++++++++++++++++++++++++++++++++++-
>  drivers/usb/gadget/f_mass_storage.c |    6 +++-
>  include/linux/usb/composite.h       |   17 +++++++++-
>  3 files changed, 81 insertions(+), 3 deletions(-)
>




--
Regards
Moiz Sonasath
Android Kernel Team
