Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab1JFTom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:44:42 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37566 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756812Ab1JFTol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:44:41 -0400
X-Sasl-enc: UnX8FIqiMqTHVUJ6QVkgGDFuVHNOzMlN+8KUCsnRUSxW 1317930280
Date: Thu, 6 Oct 2011 12:41:56 -0700
From: Greg KH <greg@kroah.com>
To: AW <arne_woerner@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acm/ttyACM0/cdc_acm does not deliver data
Message-ID: <20111006194156.GA21627@kroah.com>
References: <1317928788.76722.YahooMailNeo@web30301.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317928788.76722.YahooMailNeo@web30301.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:19:48PM -0700, AW wrote:
> Hi!
> 
> I made some USB devices using the CDC-ACM proposal...
> They work fine with 2.6.38.8-35.fc15/amd64 and earlier.
> 
> But since 2.6.40-4.fc15/amd64 it doesnt work as before...

Can you try a kernel.org release instead of a Fedora kernel?  Does this
work on 3.0.6?  If not, please post the output of running the usbmon
tool when trying to do this to the linux-usb mailing list and we will
try to help you out there.

greg k-h
