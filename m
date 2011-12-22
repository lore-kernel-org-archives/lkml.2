Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1LVVtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:49:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59368 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1LVVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:49:07 -0500
MIME-Version: 1.0
X-Originating-IP: [192.94.92.11]
Date: Thu, 22 Dec 2011 15:49:05 -0600
Message-ID: <CABUK1ahQ2yYzaezGc=vDYPrL4ejQgC+9oNtvLeFNJRFf9wAGLw@mail.gmail.com>
Subject: runtime PM + legacy PM
From: Pavan Savoy <pavan_savoy@sify.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a need for the legacy PM to be enabled when device/drivers
run-time PM is supported ?
Should the legacy suspend/resume be disabled when run-time PM is enabled ?
