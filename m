Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0JAVEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:04:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab0JAVEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:04:10 -0400
Message-ID: <4CA64CC1.5050702@zytor.com>
Date: Fri, 01 Oct 2010 14:04:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: "stable@kernel.org" <stable@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Please promote to stable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please promote the following x86 patches to stable:

1dedefd1a066a795a87afca9c0236e1a94de9bf6
d900329e20f4476db6461752accebcf7935a8055 [as soon as Linus merges it]

The latter is already tagged stable.

These two patches are needed to resolve kernel bugzilla 16322.

	-hpa
