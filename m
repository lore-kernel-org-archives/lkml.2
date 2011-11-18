Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1KRVUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:20:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59853 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1KRVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:20:14 -0500
MIME-Version: 1.0
In-Reply-To: <1321486665-12929-1-git-send-email-seth.forshee@canonical.com>
References: <1321486665-12929-1-git-send-email-seth.forshee@canonical.com>
Date: Fri, 18 Nov 2011 14:20:12 -0700
Message-ID: <CAGdLNWEKLk7BBaFkLiWTngG=b9rEm9QPCmMusLcTUdUM=AeLHw@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Fix machines that don't support HCI_SYSTEM_EVENT
From: Azael Avalos <coproscefalo@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qosmio X500-X505 series are also affected by this
"infinite loop", this patch fixes the problem on these
laptops.

Tested-by: Azael Avalos <coproscefalo@gmail.com>
