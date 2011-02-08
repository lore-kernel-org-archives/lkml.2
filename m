Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1BHXnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:43:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab1BHXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:43:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6251"; a="73691847"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] msm: Use explicit GPLv2 licenses
Date: Tue,  8 Feb 2011 15:43:13 -0800
Message-Id: <1297208593-16368-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1297208593-16368-1-git-send-email-davidb@codeaurora.org>
References: <1297208593-16368-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a BSD-style license in Code Aurora Forum authored files with
an explicit GPLv2.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.h             |   34 ++++++++------------------
 arch/arm/mach-msm/clock-pcom.h             |   34 ++++++++------------------
 arch/arm/mach-msm/include/mach/clk.h       |   34 ++++++++------------------
 arch/arm/mach-msm/include/mach/irqs-7x30.h |   34 ++++++++------------------
 arch/arm/mach-msm/include/mach/irqs-8960.h |   33 ++++++++-----------------
 arch/arm/mach-msm/include/mach/irqs-8x50.h |   34 ++++++++------------------
 arch/arm/mach-msm/include/mach/sirc.h      |   34 ++++++++------------------
 arch/arm/mach-msm/include/mach/smp.h       |   33 ++++++++-----------------
 arch/arm/mach-msm/scm-boot.h               |   35 +++++++++------------------
 arch/arm/mach-msm/scm.h                    |   35 +++++++++------------------
 10 files changed, 112 insertions(+), 228 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index e16f72f..0bc6ab0 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ARCH_ARM_MACH_MSM_CLOCK_7X30_H
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 2c813f1..4a49133 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ARCH_ARM_MACH_MSM_CLOCK_PCOM_H
diff --git a/arch/arm/mach-msm/include/mach/clk.h b/arch/arm/mach-msm/include/mach/clk.h
index c05ca40..2e4a114 100644
--- a/arch/arm/mach-msm/include/mach/clk.h
+++ b/arch/arm/mach-msm/include/mach/clk.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 #ifndef __MACH_CLK_H
 #define __MACH_CLK_H
diff --git a/arch/arm/mach-msm/include/mach/irqs-7x30.h b/arch/arm/mach-msm/include/mach/irqs-7x30.h
index 67c5396..3afb46e 100644
--- a/arch/arm/mach-msm/include/mach/irqs-7x30.h
+++ b/arch/arm/mach-msm/include/mach/irqs-7x30.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ASM_ARCH_MSM_IRQS_7X30_H
diff --git a/arch/arm/mach-msm/include/mach/irqs-8960.h b/arch/arm/mach-msm/include/mach/irqs-8960.h
index c7f083c..bfa5e9f 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8960.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8960.h
@@ -1,29 +1,18 @@
 /* Copyright (c) 2011 Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Code Aurora nor
- *       the names of its contributors may be used to endorse or promote
- *       products derived from this software without specific prior written
- *       permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
- * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
- * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
- * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
- * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
- * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
- * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ASM_ARCH_MSM_IRQS_8960_H
diff --git a/arch/arm/mach-msm/include/mach/irqs-8x50.h b/arch/arm/mach-msm/include/mach/irqs-8x50.h
index de3d8fe..f70363f 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8x50.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8x50.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2008-2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ASM_ARCH_MSM_IRQS_8XXX_H
diff --git a/arch/arm/mach-msm/include/mach/sirc.h b/arch/arm/mach-msm/include/mach/sirc.h
index 7281337..1b0b10c 100644
--- a/arch/arm/mach-msm/include/mach/sirc.h
+++ b/arch/arm/mach-msm/include/mach/sirc.h
@@ -1,30 +1,18 @@
 /* Copyright (c) 2008-2009, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ASM_ARCH_MSM_SIRC_H
diff --git a/arch/arm/mach-msm/include/mach/smp.h b/arch/arm/mach-msm/include/mach/smp.h
index a95f7b9..7a58e87 100644
--- a/arch/arm/mach-msm/include/mach/smp.h
+++ b/arch/arm/mach-msm/include/mach/smp.h
@@ -1,29 +1,18 @@
 /* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in the
- *       documentation and/or other materials provided with the distribution.
- *     * Neither the name of Code Aurora nor
- *       the names of its contributors may be used to endorse or promote
- *       products derived from this software without specific prior written
- *       permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
- * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
- * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
- * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
- * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
- * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
- * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 
 #ifndef __ASM_ARCH_MSM_SMP_H
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
index 68f9b61..d94e1c5 100644
--- a/arch/arm/mach-msm/scm-boot.h
+++ b/arch/arm/mach-msm/scm-boot.h
@@ -1,29 +1,18 @@
 /* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 #ifndef __MACH_SCM_BOOT_H
 #define __MACH_SCM_BOOT_H
diff --git a/arch/arm/mach-msm/scm.h b/arch/arm/mach-msm/scm.h
index 261786b..84854e9 100644
--- a/arch/arm/mach-msm/scm.h
+++ b/arch/arm/mach-msm/scm.h
@@ -1,29 +1,18 @@
 /* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above
- *       copyright notice, this list of conditions and the following
- *       disclaimer in the documentation and/or other materials provided
- *       with the distribution.
- *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
- *       contributors may be used to endorse or promote products derived
- *       from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
- * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
- * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
- * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
- * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
  */
 #ifndef __MACH_SCM_H
 #define __MACH_SCM_H
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

