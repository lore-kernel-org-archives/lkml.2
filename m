Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0KXQ4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:56:49 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48301 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0KXQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:56:40 -0500
Subject: Re: [PATCH] WMI: Cater for multiple events with same GUID
From: Colin Ian King <colin.king@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101124165343.GK2150@srcf.ucam.org>
References: <1290181202-9439-1-git-send-email-colin.king@canonical.com>
	 <20101124165343.GK2150@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 16:56:33 +0000
Message-ID: <1290617793.1872.1.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm preparing a WMI driver that will use this - I will submit this in
the next few days.

On Wed, 2010-11-24 at 16:53 +0000, Matthew Garrett wrote:
> I've applied this to -next - is there anything that needs this that 
> would benefit from it in .37?
> 


