Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1GTPi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:38:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39096 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1GTPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:38:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=EzM6L2QiLmcP9WzhqwP84qvLFyfC546slpQn2gsbwiSy0yscJXXEeFuJDRhrklLhD
	oh40zKgeCui1njxpUC4ew==
MIME-Version: 1.0
In-Reply-To: <201107192034.33466.charles.opondo@lshtm.ac.uk>
References: <201107192034.33466.charles.opondo@lshtm.ac.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 20 Jul 2011 09:38:34 -0600
Message-ID: <CAErSpo7RMn0+30n9FCibvgw6Ym0pKuxJaqUdfDMJg_oFjDCt6Q@mail.gmail.com>
Subject: Re: Bug Report
To: Charles Opondo <charles.opondo@lshtm.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:34 AM, Charles Opondo
<charles.opondo@lshtm.ac.uk> wrote:
> There appears to be a bug with Linux 2.6.38-11-generic kernel; my synaptic touchpad appears not to work with this kernel. I'm not sure if this is a problem specific to my Asus B50A laptop or a general one. Have you had any similar reports?

Is this a regression, i.e., did the touchpad work with a previous
kernel and only started failing with 2.6.38?  Do you have a way to
test a current kernel, e.g., 3.0-rc7 to see whether it's already been
fixed?

I assume this is a USB device, so I cc'd linux-usb.  If you can
collect the complete dmesg logs from the newest kernel that works and
from 2.6.38, and compare them, there might be a clue.

Bjorn
