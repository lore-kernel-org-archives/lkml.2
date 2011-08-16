Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1HPKtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 06:49:16 -0400
Received: from smtp.unlimitedmail.net ([94.127.184.244]:60831 "EHLO
	dcnode-02.unlimitedmail.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751295Ab1HPKtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 06:49:13 -0400
Message-Id: <201108161049.p7GAn05I028686@dcnode-02.unlimitedmail.net>
Date: Tue, 16 Aug 2011 16:18:55 +0530
From: "J. Bakshi" <j.bakshi@unlimitedmail.org>
To: linux-kernel@vger.kernel.org
Subject: LCD brightness not reflected at brightness file
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAgMAAAAqbBEUAAAADFBMVEW2UCaWJQ3jnnRrCARshP4hAAACQElEQVQokRWSzU4aYRiFDwhiJjGAimxqRlzhbGpDm24wjmhTQtIIOlMag6GXUP92Tj5obcaaJqRJidvBlDi8N1FpbUzcFGgNK0MvgZKZsmHydVw+OWd1zgOiaH+98Ejt/SGCaTDlmZMYdl+cEmjMKQydBL97kJFAYlfbVab5KHS5AONrnoenPhVHbU1A4yezEYup+1crGRhtfuv9kPZtLRcz8Mw4ykJ1UPJF72Qkg09SdHFFxkY/iZW1HxNSY/zLSbS1B9sKLW7TaU3yB55DHXnjL4n0m1BSRNOZoKo8IXqx1YVqZ6is+C0YwS7Gml4q5/mdRFEbSkig95xbZEaHCMpEJ5x3yPRzyCEqzcTm0lMUscEEE0gfm/64RwPbpJyTIlPbLnNoMoku1JxNAHyTzhzQO2fWXL5PKgOD9H+fPQW4lUqnJk0OqkYEWorETE0SBzrmwFP0lj7Gn1r6qgZ4z8/jM/GVm7Mcg5apH4db8d43PccBoY6oHGAdPRuBX2m8DrSn+Y1+GALLNtLskjWFQHaEXsvMFvsFgc5sD4oyZT39wjiJQwu5ljRbSheqQnHIEfGfV2n+oL7KeBetvrcumQc1lbsQWJVj2fkDk/dceCwqi6qn4y7gcLxhlnCY71DgyGG4yNuvKnyPfBtzNipdRy6r/YXI9Pc+dM7WocqIHGU7KDlsSQn7wsHfSS9MVti9Dau5jfYkuU9Y13Z45+havZRg6H/Xhgk+au7c61L6FVD3XVu44IpkPpxUtnrqkiXRf3v/EFxxaZnHAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SOLTECSIS-MailScanner-ID: p7GAn05I028686
X-SOLTECSIS-MailScanner-From: j.bakshi@unlimitedmail.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I have compiled linux kernel 3.0.1. The LCD current brightness
is show by /sys/class/backlight/acpi_video0/actual_brightness

I can also control brightness by <Fn> key and correctly read by
/sys/class/backlight/acpi_video0/actual_brightness

BUT 

echo 0 > /sys/class/backlight/acpi_video0/brightness 

echo 8 > /sys/class/backlight/acpi_video0/brightness

etc.... has no effect !!!

Could anyone give me any clue please ?

TIA
