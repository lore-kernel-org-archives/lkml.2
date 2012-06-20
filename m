Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2FTNcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:32:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2FTNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <1338704660-30921-1-git-send-email-devendra.aaru@gmail.com>
References: <1338704660-30921-1-git-send-email-devendra.aaru@gmail.com>
Date: Wed, 20 Jun 2012 19:02:41 +0530
Message-ID: <CAHdPZaMXBOr8Kn-jjhESmA534QRNqfGmkLM62VQmdUdL+k400w@mail.gmail.com>
Subject: Re: [PATCH] rtc/rtc-spear: free the config right after the rtc_device_unregister
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


