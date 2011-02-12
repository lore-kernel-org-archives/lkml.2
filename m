Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1BLJfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:35:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44115 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1BLJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20110212093120.GF17755@angua.secretlab.ca>
References: <1296964096-30760-1-git-send-email-thomas@wytron.com.tw>
 <1297143803-2771-1-git-send-email-thomas@wytron.com.tw> <20110212093120.GF17755@angua.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 12 Feb 2011 02:34:56 -0700
X-Google-Sender-Auth: y85lnHUncl9HoaqAfPg-rZkLbDc
Message-ID: <AANLkTik6UcF0v43wRowV6+0xtKC6Kkwh30xvArefW23N@mail.gmail.com>
Subject: Re: [PATCH v7] spi: add OpenCores tiny SPI driver
To: Thomas Chou <thomas@wytron.com.tw>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 2:31 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Feb 08, 2011 at 01:43:23PM +0800, Thomas Chou wrote:
>> This patch adds support of OpenCores tiny SPI driver.
>>
>> http://opencores.org/project,tiny_spi
>>
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>> v2 minor cleanup, same as Grant suggest for spi_altera.
>> v3 rename driver to spi_oc_tiny as Grant suggested.
>>    set version to tiny-spi-rtlsvn2 as Jonas suggested.
>> v4 add dts binding doc.
>> v5 use devm_* to help cleanup.
>>    add of gpio support.
>> v6 check len from of_get_property.
>>    fix kerneldoc in header.
>> v7 remove default n from Kconfig.
>>
>>  .../devicetree/bindings/spi/spi_oc_tiny.txt        |   12 +
>>  drivers/spi/Kconfig                                |    7 +
>>  drivers/spi/Makefile                               |    1 +
>>  drivers/spi/spi_oc_tiny.c                          |  421 ++++++++++++++++++++
>>  include/linux/spi/spi_oc_tiny.h                    |   20 +
>>  5 files changed, 461 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/spi/spi_oc_tiny.txt
>>  create mode 100644 drivers/spi/spi_oc_tiny.c
>>  create mode 100644 include/linux/spi/spi_oc_tiny.h
>
> Hi Thomas
>
> Still need documentation on the binding in
> Documentation/devicetree/bindings before I pick up this driver.  This
> goes for all the new drivers with dt bindings.

Oops, nevermind.  I see it.  Sorry for the noise.

g.
