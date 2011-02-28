Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1B1VlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:41:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33798 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1B1Vk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dPDEQ2o2VctO5HEhV3fmmJ899EsOXwBEObdnB2Dr0dIcRsvRxIxiXuIgfTowbU2vR+
         wli7AfnD74SPTZQPXvDe8m/RUQjxaj53sFNggPXanBkW1SeXuOo4ZBmBZivmyyo/V9PD
         RGIWZYZ0kp942s82oNG7XbUlvhkDeR8482Xgg=
Date: Mon, 28 Feb 2011 23:40:54 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc6: SysRq broken?
Message-ID: <20110228214054.GA18538@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just strikes me that SysRq is broken here:
Alt+SysRq+h doesn't print anything

CONFIG_MAGIC_SYSRQ=y
CONFIG_INPUT_EVDEV=y
kernel.sysrq=1
echo h >/proc/sysrq-trigger works

Keyboard is USB one, "Logitech HID compliant keyboard".
