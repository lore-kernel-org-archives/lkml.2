Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1CHAnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:43:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40307 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040Ab1CHAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:43:04 -0500
X-Sasl-enc: 7VJm56Fn2e3jfr5evWaMFAyUPYLMFQGvXgxbsb3DPhIv 1299544983
Date: Mon, 7 Mar 2011 21:43:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo
 ThinkPads.
Message-ID: <20110308004300.GA11532@khazad-dum.debian.net>
References: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011, Manoj Iyer wrote:
> Please consider the following patch that adds support for auto loading 
> thinkpad_acpi module on newer Lenovo ThinkPads that have HKEY HID set 
> to LEN0068 instead of IBM0068. 

Does the driver do anything useful on these Lenovo thinkpads?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
