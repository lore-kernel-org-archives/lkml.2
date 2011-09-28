Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1I1NUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:20:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1I1NUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:20:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 01/24] fix default __strnlen_user macro
Date: Wed, 28 Sep 2011 15:20:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-2-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281520.09981.arnd@arndb.de>
X-Provags-ID: V02:K0:TA8tByiIeCYWNuvDmnc7a2o3eVFkqCIud/yTpbHhgBY
 izmt+IliJl16OoaTw9jA/kjKZZMX51ySceaXnsUXZ0zLLHL+Fn
 bETSZhp0PM2ksW7jZd0oLF+hFDw5j6L/S90gQa5bkDRoG4Ewn9
 KM4BcMy+9rDg2xvhIGFi1Gw77lGXOalGQ0i8lyuYmMaH1K27VX
 a1MCNvzR3yXu/GhO1Nq0+Fh/yYOrOunkqNMmDW4SHIrKuz5yDa
 OHdwMzNwqeVojqm2J7Nz4UXcWAKhBUi3VPj8q3dQyX0YoAqfM8
 UfoVN8Y07cjRysSAwSuo0QtQE23F3wJKUkJFO7ydMidTBi9asE
 sJ9ZoVFDEWbO36UOSzXE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> The existing __strnlen_user macro simply resolved to strnlen. However, the
> count returned by strnlen_user should include the NULL byte. This patch
> fixes the __strnlen_user macro to include the NULL byte in the count.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
