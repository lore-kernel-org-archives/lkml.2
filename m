Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1ADKSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:18:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1ADKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:18:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Ott <alan@signal11.us>
Subject: Re: [PATCH 1/1] hidraw: Added Compatibility ioctl() for 32-bit applications.
Date: Tue, 4 Jan 2011 11:18:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1294119442-6827-1-git-send-email-alan@signal11.us> <1294119442-6827-2-git-send-email-alan@signal11.us>
In-Reply-To: <1294119442-6827-2-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101041118.39602.arnd@arndb.de>
X-Provags-ID: V02:K0:IEXllBUaJyeF5jyA7ir/qGtJR6oKsMroLhuCafzvk+K
 uVathcJAh6qs2RaTZL4cK6L/SXL1YlnQu/xxx/smjWCm+CCvR/
 DsP4E9xd0Z9SZtGpqp+31R0+tr6WRQdWL3Y+GXsoNcIfIX1wcA
 1cE4T4xjcCl0xdyVIiclezdC207NfRdFRiWn5hLyUwJBOClEu4
 +5byv0LCsiVU63uE3ImoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 January 2011 06:37:22 Alan Ott wrote:
> Added the ioctl function to the compat_ioctl pointer in the
> file_operations struct. Before this, some ioctls would 
> fail for 32-bit apps on 64-bit systems.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I verified that all the ioctls for hidraw are indeed compatible.

	Arnd
