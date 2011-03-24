Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab1CXFup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:50:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab1CXFuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kwDBH8g/AoGbwgqaGg/i5JWR+DTzlF4TVGTQoKMXXGPhe/2rxIRxAD/e+jwNQnHQSX
         /19bY3WSo38ThZGNehwQ==
MIME-Version: 1.0
In-Reply-To: <20110324043652.GA4835@earth.li>
References: <20110324043652.GA4835@earth.li>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 23 Mar 2011 22:50:20 -0700
Message-ID: <AANLkTikiZ_JYUcobRF6T_=DMXCc=Em8f1U_eD_rQRSRu@mail.gmail.com>
Subject: Re: [PATCH] Re-add quirk for ServerWorks bridge secondary buses
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 9:36 PM, Jonathan McDowell <noodles@earth.li> wrote:
> I have a board with a ServerWorks CIOB-X2 bridge on it (2 in fact) that
> is not having the secondary buses off it correctly discovered with
> 2.6.38.

Is this a regression?  If so, what is the newest kernel that still
worked?  Can you include a dmesg log?  I assume that since you don't
have a standard BIOS, you don't have ACPI?

Bjorn
